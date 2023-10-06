#!/bin/bash

this_directory=$(dirname "$0")

pushd $this_directory/../site
  rm -fr public
  hugo
popd 

pushd $this_directory 
  rm -fr work
  mkdir -p work/cf4devs
  cp -R ../site/public/* work/cf4devs
  cp Staticfile work
popd

pushd $this_directory/work
  zip -r site.zip * -x "*.DS_Store"
  cf push -p ./site.zip -f ../manifest.yml
popd