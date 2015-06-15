# Deployment Guide

* Deployment Script

  For deployment of the code we are using [Capistrano](http://capistranorb.com).

* Branching System:-

  * For development we use [git feature flow](http://codebeerstartups.com/2013/04/how-to-use-git-flow-in-your-projects/).

  * For deploy on production use `master` branch, make sure your code is tested first and then push on `master`.

* Linux user:-

  To deploy on production you need access to `speedlancer` app user.

* Deployment steps:-

  * Push your code to `master` branch.

  * Run the following command from your local speedlancer directory.

    ```shell
    bundle exec cap production deploy
    ```
  * It will ask for server password, enter and press ok.

  * That's it, its done, unless you have changes in `Gemfile` or `initializers`.

  * Follow below steps only if you have changes in `Gemfile` or `initializers`.

  * Restart the unicorn server using this command from your local system.

    ```shell
    bundle exec cap production deploy:stop
    ```
  then

    ```shell
    bundle exec cap production deploy:start
    ```

  It will reload your server make sure you run last two commands one after another because first one will turn off the server.


* **Important**:-

  All the commands will run from your local machine no need to ssh in server at all, an password prompt will open up add password there and it will do the rest.
