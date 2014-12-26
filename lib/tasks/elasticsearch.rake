namespace :elasticsearch do

  task create_indices: :environment do
    puts "Creating indices..."
    User.__elasticsearch__.create_index!
  end

  task delete_indices: :environment do
    puts "Deleting indices..."    
    User.__elasticsearch__.delete_index!
  end
  
    
  task index: :environment do
    puts "Importing data..."
    User.import
  end
  
  task reindex: [
    :delete_indices,
    :create_indices,
    :index
  ]
    
end