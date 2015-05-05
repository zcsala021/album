#!/usr/bin/env python
# -*- coding: utf-8 -*- #
from __future__ import unicode_literals

# This file is only used if you use `make publish` or
# explicitly specify it as your config file.

import os
import sys
sys.path.append(os.curdir)
from pelicanconf import *

SITEURL = 'http://zcsala021.github.io'
# Where to create site's content
OUTPUT_PATH = '/home/album/pelican'
DELETE_OUTPUT_DIRECTORY = False
FEED_RSS = 'feeds/rss.xml'
FEED_ALL_ATOM = 'feeds/all.atom.xml'
CATEGORY_FEED_ATOM = None
TAG_FEED_ATOM = None
TAG_FEED_RSS = None
RELATIVE_URLS = False
# Plugins
PLUGIN_PATHS = [ '/opt/app/p/pelican-plugins' ]
PLUGINS      = [ 'tipue_search', 'neighbors', 'sitemap', 'pelican-page-hierarchy' ]
# Disqus plugin
DISQUS_SITENAME = 'zalbum'

I18N_SUBSITES = {
	'en': {
		'AUTHOR' : 'Zoltan Csala',
		'SITENAME': 'My Album',
		'SITE_DESCRIPTION' : 'My virtual album',
		'THEME' : 'theme/mudrovanja-en',
		'LOCALE' : 'en_US',
		'DEFAULT_LANG' : 'en',
		'ARTICLE_PATHS' : [],
		'MENUITEMS' : (),
		'DISQUS_SITENAME' : 'zalbum-en',
	},
}

# Following items are often useful when publishing

