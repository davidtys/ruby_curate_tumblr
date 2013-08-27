# Curate Tumblr Ruby Gem

Reblog and follow in your Tumblr from a file of links.

Grow you Tumblr audience by automating the boring tasks !

### Installation

gem install curate_tumblr

### Quick Example

require 'curate_tumblr'

**CurateTumblr.reblog( "kubricklove", "/home/tumblr" )**

reblog links in the queue of tumblr "kubricklove" where config is in 
/home/tumblr/kubricklove/kubricklove_config.yaml
and links to reblog are in 
/home/tumblr/kubricklove/links/kubricklove_links

### Features

* *polite with tumblr* : random sleep and stop if tumblr send errors
* *extract informations from posts* : other tumblrs to follow, external links to see...
* *add visibility to your reblogs* : add tags and link
* *separate follow from reblog* : not to waste Tumblr requests
* *config in realtime* : you can stop it or change parameters when running

### Important

Please note before all **you have to config oauth** for your tumblr.

You can see an example of reblog and follow for a kubrick tumblr in the *example* folder.

## Usage

### oAuth

#### Create a Tumblr

First create a test tumblr if you have not

ex : mytumblrtest.tumblr.com

#### oAuth

Follow the tumblr process to have oauth authenficiation :
https://www.tumblr.com/login?redirect_to=%2Foauth%2Fapps

more infos : http://www.tumblr.com/docs/en/api/v2#blog-likes

This application **must be authorized** by your tumblr

#### Result

At the end you must have this codes :

    consumer_key: XX        
    consumer_secret: XX     
    token: XX               
    token_secret: XX  


### Config

Curate Tumblr uses the name of your tumblr to find the folder for links (to reblog and follow) and config file

#### Create folders

Create a folder where you will have your config and links files :

ex : /home/tumblr

Create in this folder another folder with your test tumblr name :

ex : /home/tumblr/mytumblrtest

In this folder create a folder links and a folder logs

ex :

/home/tumblr/mytumblrtest/links

/home/tumblr/mytumblrtest/logs


#### Create config file

Create a config file in this folder. 

You can copy *kubricklove_config.yaml* from the example and rename it with your tumblr name :

ex  /home/tumblr/mytumblrtest/mytumblrtest_config.yaml

Put your oauth codes in the config file

  oauth:  

    consumer_key:        
    consumer_secret:     
    token:               
    token_secret: 

Congratulations! :-)


## Some examples

#### Reblog or follow from a links file

The easy way is to render tumblr links from file, with *CurateTumblr::Render* module :

require "curate_tumblr"

CurateTumblr.reblog( "mytumblrtest", "/home/tumblr" )

CurateTumblr.follow( "mytumblrtest", "/home/tumblr" )

#### Reblog or follow a link

You can also use *CurateTumblr::Curator* :

require "curate_tumblr"

curator = Curator.new( "mytumblrtest", "/home/tumblr" )

curator.reblog_and_extract( "http://joshbrooksonfilm.tumblr.com/post/58294445822/barry-lyndon-1975-kubrick-1st-viewing-if-i" )

curator.reblog_and_extract( "http://oh-lesedi.tumblr.com" )

## Config options

client: basic config for manage Tumblr
  * *is_running* : if false stop the application
  * *sleep_before_client_min and max* : random sleep before each request (important to not be blocked by Tumblr)
  * *sleep_before_follow_min and max* : random sleep before following, can simulate a queue
  * *max_requests_and_posts* : max of all requests before stop 
  * *max_posted* : max of posted (text, image) before stop
  * *max_reblogged* : max of reblogged before stop
  * *max_followed* : max of followed before stop
  * *oauth: consumer_key, consumer_secret, token, token_secret*

infos: infos to add to your posts
  * *tags* : a string with list of tags
  * *title* : to add a link to your tumblr   


## Rspec 

**Before testing code you have to set oauth and create a config file** (you can copy the example config file)

In *spec/factories.rb* change *get_tumblr_name* and *get_tumblr_directory*

in the config file set oauth
  oauth:  

    consumer_key:        
    consumer_secret:     
    token:               
    token_secret: 


## Tumblr errors

The application manage these tumblr errors :
* *Rate limit exceeded* : too much requests, try to incread the sleep time in config file **=> the application stop**
* *Bad request* : perhaps the link has been deleted
* *Too much bad requests* : there is no enough place in the queue, or there is a problem with your tumblr **=> the application stop**


## Tips

### Realtime

Config file is read before each operation.

You can stop a cron reblog or follow by changing *is_running* in config file 
(ex /home/tumblr/mytumblrtest/mytumblrtest_config.yaml) 

*is_running:   false*

you can also change other parameters (max to reblog, sleep time...)


### Problems

If strange things happen :
* please note by default reblogged posts are published in queue (not visible)
* check there is enough place in the queue (max 300 posts in queue)
* check your tumblr name (ex : mytumblrtest if you have created mytumblrtest.tumblr.com)
* check oauth is ok in your config file
* check log file (ex in /home/tumblr/mytumblrtest/logs)

### About reblog

To reblog a post you need its reblog key
You have to send a request to tumblr with the post tumblr and id
You can use :

*CurateTumblr::Tumblr::ExtractLinks.get_reblog_key_from_reblog_url*


## Todo

* memory (to not follow tumblrs already followed)
* hidden oauth (are you enough paranoid ?)


## Copyright

The Curate Tumblr gem is Copyright (c) 2013 David Tysman and is licensed under the MIT License.
Feel free to use it for any project.

Tumblr is Copyright (c) Tumblr, Inc. The Curate Tumblr gem is NOT affiliated with Tumblr, Inc.
