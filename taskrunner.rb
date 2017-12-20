require 'dotenv/load'
require 'httparty'
require 'pry'
require 'json'
require 'csv'

begin
	raise "You need to include HAPIKEY" if !(ENV['HAPIKEY'])
	raise "You need to include an API ENDPOINT" if !(ENV['ENDPOINT'])
	raise "You need to include PROPERTIES" if !(ENV['PROPERTIES'])
	columns = ENV['PROPERTIES'].split(',')
	raise "You didn't include a source.csv file" if !(File.file? './source.csv')
rescue Exception => error
	puts error
	exit
end

records_to_upload = []
CSV.foreach('./source.csv').with_index do |row, index|
	record = {}
	record['objectId'] = row[0]
	record['properties'] = []
	records_to_upload.push record

	columns.each_with_index do |column_name, column_index|
		property = {
			name: column_name,
			value: row[column_index + 1]
		}
		record['properties'].push property
	end
end

while true
	puts "#{records_to_upload.size} remaining"
	if records_to_upload.size <= 0
		break
	end

	url = "#{ENV['ENDPOINT']}?hapikey=#{ENV['HAPIKEY']}"
	body = records_to_upload.pop(100).to_json
	headers = {
		'Content-Type': 'application/json'
	}

	if ENV['FOR_REAL'] == 'yes'
		response = HTTParty.post(url, body: body, headers: headers)
		puts response.response.code
	else
		puts body
	end
end

exit
