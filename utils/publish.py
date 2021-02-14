# -*- coding: utf-8 -*-


"""
This script helps with drafts publication process:

* Calculates reading time and updates post header
* Sets current date to post header
* Renames assets subfolder to match current date
* Moves post from '_drafts' to '_posts' and preppends current date

Args:
 1. Draft file name under '_drafts' folder
 2. Draft folder name under 'assets' folder

"""

import sys
import os
import re
import utils.readtime
from datetime import datetime


now = datetime.now().strftime('%Y-%m-%d')

draft_name = sys.argv[1]
draft_path = os.path.join('_drafts', draft_name)
dir_name = sys.argv[2]


# 1. Update post with correct urls and readtime
# 1.0 Read draft
with open(draft_path, 'r') as f:
    data = f.read()

# 1.1 Update date
print('1.1 Updating date...')
updated_date = re.sub('\nreadtime:', '\ndate: '+now+'\nreadtime:', data)

# 1.2 Update refs
print('1.2 Updating assets refs...')
fixed_url = re.sub('\/assets\/(\w*)', '/assets/'+now, updated_date)

# 1.3. Update post readtime
print('1.3 Updating readtime...')
post_readtime = utils.readtime.readtime(draft_path)
deploy = re.sub('\nreadtime: (\d+)\n', '\nreadtime: '+str(post_readtime)+'\n', fixed_url)

# 1.4 Write draft
print('1.4 Writing...')
with open(draft_path, 'w') as f:
    f.write(deploy)


# 2. Rename draft assets folder to deployable folder, current date
print('2. Renaming assets subfolder...')
os.rename('assets/test','assets/'+now)

# 3. Move draft file to _posts, preppending current date
print('3. Moving draft to _posts')
os.rename(draft_path, '_posts/'+now+'-'+draft_name)

