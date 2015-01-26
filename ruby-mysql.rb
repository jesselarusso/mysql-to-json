require 'mysql'
require 'json'
require 'pry'

host = 'use env variable'
username = 'use env variable'
password = 'use env variable'
database = 'use env variable'

begin
  db = Mysql.new(host, username, password, database)
rescue Mysql::Error
  puts "could not connect"
  exit 1
end

begin
  result = db.query "select name, chrom, txStart, txEnd from refGene"

  rows = []
  result.each_hash do |row|
    row['index'] = rows.length
    rows << row
  end

  File.delete('refGene.json') if File.exist?('refGene.json')
  output = File.open "refGene.json", "w"
  output.puts({ 'refGene' => rows }.to_json)
  output.close

  result.free
ensure
  db.close
end
