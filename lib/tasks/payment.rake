namespace :payment do

  desc "payout artists of confirmed charged past deals."
  task payout_artists: :environment do
    PaymentJob.payout_artists
    puts ''; puts 'finished...'
  end

end