#!/bin/bash
# @Author: wangding
# @Date:   2016-11-06 18:11:30
# @Last Modified by:   wangding
# @Last Modified time: 2016-11-06 19:14:39
cd $(pwd)/wordpress/wp-content/themes
git clone https://github.com/studiorabota/sage-twig-theme.git
npm install
bower install
curl -o installer -SL https://getcomposer.org/installer
php installer
php composer.phar  update
gulp


