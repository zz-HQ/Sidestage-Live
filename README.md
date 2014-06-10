Sidestage
=========

Sidestage is a community for musicians and artists.

##Requirements

**Install RVM (or rbenv)**

	\curl -sSL https://get.rvm.io | bash -s stable
	
**Install Ruby 2.1.0**

	rvm install ruby-2.1.0
	
**Install Brew**

	ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
	
**Install Imagemagick**

	brew install imagemagick

##How to run Sidestage?

**Install all required gems**

	bundle install
	
**Start the server**

	rails server
	
## How to deploy to Heroku?

_No clue yet_

## Yahoo Currency Exchange API

    http://finance.yahoo.com/webservice/v1/symbols/allcurrencies/quote
    https://query.yahooapis.com/v1/public/yql?format=json&env=store://datatables.org/alltableswithkeys&q=select%20*%20from%20yahoo.finance.xchange%20where%20pair%20in%20%28%27USDEUR%27%29
    