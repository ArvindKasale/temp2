class PutData < ActiveRecord::Base
data=Hash.new
data[:first_name]="MMMhgjnhjnhgjMMMMMM"
data[:last_name]="NNNNghjhgjNNNNNNNN"
puts "Hello in the recurring script"
@request=Request.new(data)
@request.save
end
