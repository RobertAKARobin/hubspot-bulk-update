require 'dotenv/load'
require 'httparty'
require 'pry'
require 'json'
require 'csv'

begin
	columns = ENV['PROPERTIES'].split(',')
	if !(columns.include? 'dealId')
		raise "You need to include dealId"
	end
	if !(File.file? './source.csv')
		raise "You didn't include a source.csv file"
	end
rescue Exception => error
	puts error
	exit
end

records = []
CSV.foreach('./source.csv').with_index do |row, index|
	record = {}
end

