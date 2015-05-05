#!/usr/bin/env python
# -*- coding: utf-8 -*- #
from __future__ import unicode_literals

# General settings

AUTHOR = 'Золтан Чала'
SITENAME = u'Мој албум'
SITESUBTITLE = 'Мој албум са сликама'
SITEURL = 'http://zcsala021.github.io'
# Where is content stored
PATH = 'content'
TIMEZONE = 'Europe/Zurich'
LOCALE = 'sr_RS'
DEFAULT_LANG = 'sr'
DATE_FORMATS = {
	'sr' : '%d-%b-%Y',
	'en' : '%d/%b/%Y'
}
DEFAULT_CATEGORY = 'picture'
DEFAULT_DATE_FORMAT = ('%d %m %Y')
DISPLAY_PAGES_ON_MENU = False
DISPLAY_CATEGORIES_ON_MENU = False
# static paths will be copied under the same name
STATIC_PATHS = [
	'static'
]
EXTRA_PATH_METADATA = {
    'static/image/favicon.ico' : {'path': 'favicon.ico'}
}
TYPOGRIFY = True
DELETE_OUTPUT_DIRECTORY = True
TAG_CLOUD_STEPS = None
TAG_CLOUD_MAX_ITEMS = None

# Archive options
YEAR_ARCHIVE_SAVE_AS = ''	
MONTH_ARCHIVE_SAVE_AS = ''

# Article options
ARTICLE_PATHS = []
ARTICLE_URL = ''
ARTICLE_SAVE_AS = ''

# Page options
PAGE_PATHS = [ 'sr' ]
PAGE_URL = '{slug}/'
PAGE_SAVE_AS = '{slug}/index.html'

# Tags options
TAGS_SAVE_AS = ''
TAG_SAVE_AS = ''

# Feed generation is usually not desired when developing
FEED_DOMAIN = SITEURL
FEED_RSS = None
FEED_ALL_ATOM = None
CATEGORY_FEED_ATOM = None
TAG_FEED_ATOM = None
TAG_FEED_RSS = None
TRANSLATION_FEED_ATOM = None

# Uncomment following line if you want document-relative URLs when developing
RELATIVE_URLS = True

# Items appearing in main menu
MENUITEMS = ()

# Specify only article that is being written
WRITE_SELECTED = []

# Blogroll
LINKS = False

# Social widget
SOCIAL = ()

THEME = 'theme/mudrovanja-sr'

# Where to create site
OUTPUT_PATH = 'dev/'
# Whether to copy article sources
OUTPUT_SOURCES = False

# Plugins
PLUGIN_PATHS = [ '/opt/app/p/pelican-plugins' ]
PLUGINS      = [ 'i18n_subsites', 'tipue_search', 'neighbors', 'sitemap', 'pelican-page-hierarchy' ]

# Options for pelican-page-hierarchy
# Maximum size of resized photo, any dimension
MAX_RSZD_SIZE = 800
# Maximum size of thumbnail photo, any dimension
MAX_THMB_SIZE = 200
# Maximum size of album thumbnail, any dimension
MAX_ALBM_SIZE = 400


# Little index page - missing link in navigation
TEMPLATE_PAGES = {
	'index.html' : 'sr/album/index.html',
}

# Options for i18n_subsites plugin
# mapping: language_code -> settings_overrides_dict
I18N_SUBSITES = {
	'en': {
		'AUTHOR' : 'Zoltan Csala',
		'SITENAME': 'My Album',
		'SITE_DESCRIPTION' : 'My virtual album',
		'THEME' : 'theme/mudrovanja-en',
		'LOCALE' : 'en_US',
		'DEFAULT_LANG' : 'en',
		'PAGE_PATHS' : [ 'en' ],
		'PAGE_URL' : '{slug}/',
		'PAGE_SAVE_AS' : '{slug}/index.html',
		'OUTPUT_PATH' : 'dev/',
		'MENUITEMS' : (),
	},
}

SITEMAP = {
	'format': 'xml',
	'priorities': {
		'articles': 0.5,
		'indexes': 0.5,
		'pages': 0.5
	},
	'changefreqs': {
		'articles' : 'monthly',
		'indexes' : 'daily',
		'pages' : 'monthly'
	}
}
