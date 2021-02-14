# -*- coding: utf-8 -*-

"""
This script calculates mean reading time of a post, assuming 200 words per minute.

In order to optimize word count to some extent the script filters some text, in particular:

* Post header (block between '---')
* Markdown related code and tags
* HTML tags

"""

import re


def _filter_header(data):
    return re.sub('(---[^*]*---)\n', '', data)


def _filter_markdown(data):
    return re.sub('\$\$.*\$\$', '', re.sub('(```.*[^*]*```)', '', re.sub('\{:.*\}', '', data)))


def _filter_html(data):
    return re.sub('<\/?[^>]*>', '', data)


def readtime(path, words_per_minute=200):
    with open(path, 'r') as f:
        data = f.read()
    filtered = _filter_header(_filter_markdown(_filter_html(data)))
    words = filtered.split(' ')
    return round(len(words)/words_per_minute)


