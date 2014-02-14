#! /usr/bin/env bash

echo "select deploy to"
echo "1 release"
echo "2 evaluation"
read -p "please input (1/2):" version

case $version in
  1)
    bundle exec mina deploy -f config/deploy_release.rb
  ;;
  2)
    bundle exec mina deploy -f config/deploy_evaluation.rb
  ;;
  *)
    echo "please input 1 or 2"
    exit 1
  ;;
esac
