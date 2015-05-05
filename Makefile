PY?=python
PELICAN?=pelican
PELICANOPTS=

BASEDIR=$(CURDIR)
INPUTDIR=$(BASEDIR)/content
# We will have 2 output directories:
#   - $PRODDIR for production (published on GitHub)
#   - $DEVDIR for development (accessible through local HTTP server)
PRODDIR=/home/album/pelican
DEVDIR=$(BASEDIR)/dev
CONFFILE=$(BASEDIR)/pelicanconf.py
PUBLISHCONF=$(BASEDIR)/publishconf.py

THEME=mudrovanja
FTP_HOST=localhost
FTP_USER=anonymous
FTP_TARGET_DIR=/

SSH_HOST=localhost
SSH_PORT=22
SSH_USER=root
SSH_TARGET_DIR=/var/www

S3_BUCKET=my_s3_bucket

CLOUDFILES_USERNAME=my_rackspace_username
CLOUDFILES_API_KEY=my_rackspace_api_key
CLOUDFILES_CONTAINER=my_cloudfiles_container

DROPBOX_DIR=~/Dropbox/Public/

GITHUB_PAGES_BRANCH=gh-pages

DEBUG ?= 0
ifeq ($(DEBUG), 1)
	PELICANOPTS += -D
endif

help:
	@echo 'Makefile for a pelican Web site                                        '
	@echo '                                                                       '
	@echo 'Usage:                                                                 '
	@echo '   make html                        (re)generate the web site          '
	@echo '   make clean                       remove the generated files         '
	@echo '   make regenerate                  regenerate files upon modification '
	@echo '   make publish                     generate using production settings '
	@echo '   make serve [PORT=8000]           serve site at http://localhost:8000'
	@echo '   make devserver [PORT=8000]       start/restart develop_server.sh    '
	@echo '   make stopserver                  stop local server                  '
	@echo '   make ssh_upload                  upload the web site via SSH        '
	@echo '   make rsync_upload                upload the web site via rsync+ssh  '
	@echo '   make dropbox_upload              upload the web site via Dropbox    '
	@echo '   make ftp_upload                  upload the web site via FTP        '
	@echo '   make s3_upload                   upload the web site via S3         '
	@echo '   make cf_upload                   upload the web site via Cloud Files'
	@echo '   make github                      upload the web site via gh-pages   '
	@echo '                                                                       '
	@echo 'Set the DEBUG variable to 1 to enable debugging, e.g. make DEBUG=1 html'
	@echo '                                                                       '

html:
	$(PELICAN) $(INPUTDIR) -o $(DEVDIR) -s $(CONFFILE) $(PELICANOPTS)

publish:
	$(PELICAN) $(INPUTDIR) -o $(PRODDIR) -s $(PUBLISHCONF) $(PELICANOPTS)
	
clean:
	[ ! -d $(DEVDIR) ] || rm -rf $(DEVDIR)

regenerate:
	$(PELICAN) -r $(INPUTDIR) -o $(DEVDIR) -s $(CONFFILE) $(PELICANOPTS)

trextract:
	./msgext.py -m ./theme/$(THEME)-msg-en.po -i ./theme/$(THEME)-tmpl/templates/*.html
	
trcompile:
	./msgput.py -m ./theme/$(THEME)-msg-en.po -i ./theme/$(THEME)-tmpl/templates/*.html -o ./theme/$(THEME)-en/templates
	./msgput.py -m ./theme/$(THEME)-msg-sr.po -i ./theme/$(THEME)-tmpl/templates/*.html -o ./theme/$(THEME)-sr/templates

staticrefresh:
	rm -rf ./theme/$(THEME)-en/static
	rm -rf ./theme/$(THEME)-sr/static
	cp -R ./theme/$(THEME)-tmpl/static ./theme/$(THEME)-en/static
	cp -R ./theme/$(THEME)-tmpl/static ./theme/$(THEME)-sr/static
	
serve:
ifdef PORT
	cd $(DEVDIR) && $(PY) -m pelican.server $(PORT)
else
	cd $(DEVDIR) && $(PY) -m pelican.server
endif

devserver:
ifdef PORT
	$(BASEDIR)/develop_server.sh restart $(PORT)
else
	$(BASEDIR)/develop_server.sh restart
endif

stopserver:
	kill -9 `cat pelican.pid`
	kill -9 `cat srv.pid`
	@echo 'Stopped Pelican and SimpleHTTPServer processes running in background.'
	
ssh_upload: publish
	scp -P $(SSH_PORT) -r $(PRODDIR)/* $(SSH_USER)@$(SSH_HOST):$(SSH_TARGET_DIR)

rsync_upload: publish
	rsync -e "ssh -p $(SSH_PORT)" -P -rvzc --delete $(PRODDIR)/ $(SSH_USER)@$(SSH_HOST):$(SSH_TARGET_DIR) --cvs-exclude

dropbox_upload: publish
	cp -r $(PRODDIR)/* $(DROPBOX_DIR)

ftp_upload: publish
	lftp ftp://$(FTP_USER)@$(FTP_HOST) -e "mirror -R $(PRODDIR) $(FTP_TARGET_DIR) ; quit"

s3_upload: publish
        s3cmd sync $(PRODDIR)/ s3://$(S3_BUCKET) --acl-public --delete-removed --guess-mime-type

cf_upload: publish
	cd $(PRODDIR) && swift -v -A https://auth.api.rackspacecloud.com/v1.0 -U $(CLOUDFILES_USERNAME) -K $(CLOUDFILES_API_KEY) upload -c $(CLOUDFILES_CONTAINER) .

github: publish
	ghp-import -b $(GITHUB_PAGES_BRANCH) $(PRODDIR)
	git push origin $(GITHUB_PAGES_BRANCH)

.PHONY: html help clean regenerate serve devserver publish ssh_upload rsync_upload dropbox_upload ftp_upload s3_upload cf_upload github
