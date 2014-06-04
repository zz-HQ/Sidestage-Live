namespace :currency do

  desc "Updates currency rates by pulling current rates from yahoo finance service."
  task update_rates: :environment do
    CurrencyService.update_all_rates
  end
    
end