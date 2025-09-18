# academia-dl

Download PDFs from academia dot edu without logging in or creating an account.

## Usage

Install the necessary gems with [bundler](https://bundler.io/) or `gem install nokogiri open_uri_redirections addressable`. Then run:

    ./academia-dl.rb "https://www.academia.edu/rest/of/url" 

## Docker Usage

    docker run -ti -v "$(pwd)":/data ryanfb/academia-dl "https://www.academia.edu/rest/of/url"

## Tip Jar

Appreciate my work? [Check out my Tip Jar for ways you can support it](https://ryanfb.xyz/etc/tip-jar)
