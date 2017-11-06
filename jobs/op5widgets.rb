#USERNAME  =  DashApp.config.default_username
#PASSWORD  =  DashApp.config.default_password

config = YAML.load File.open("op5widgets.yml")
USERNAME  =  config["default_username"]
PASSWORD  =  config["default_password"]

monitors  =  config["monitors"]
data_tag  = "op5"

puts "monitors: #{config}"

def format_service_desc(s)
  return s if s.length < 23
  s[0..23] + "\n" + s[24..60] + (s.length > 60 ? '.....' : '')
end

def format_time(t)
  m,s = t.divmod 60
  h,m = m.divmod 60
  d,h = h.divmod 24
  mm,d = d.divmod 30
  if mm == 0
    if d == 0
      if h == 0
        "#{m} min#{s.floor} sec"
      else
        "#{h} hours #{m} min"
      end
    else
      "#{d} days #{h} hours"
    end
  else
    "#{m} months #{d} days"
  end
end

SCHEDULER.every '20s', first_in: '1s', allow_overlapping: false do |_job|

  monitors.each do |env, url1|
    c = JSONClient.new
    c.ssl_config.verify_mode = OpenSSL::SSL::VERIFY_NONE
    c.set_auth(url1, USERNAME, PASSWORD)
    c.force_basic_auth = true
    url = url1 + 'filter/query?format=json&query=%5Bnotifications%5D+all&limit=1'
    r = c.get(url)
    puts "got url response was a #{r.status}"  unless r.status == 200
    next if r.nil? || r.status != 200
    str = "#{data_tag}_#{env}"
    timestamp = r.body.first['start_time']
    time = Time.at(timestamp).strftime('%e %b %H:%M')
    service = format_service_desc(r.body.first['service_description'])
    retval = { "eventstime".to_sym    => time,
               "eventshost".to_sym    => r.body.first['host_name'],
               "eventservice".to_sym  => service,
               "eventstate".to_sym    => r.body.first['state_text'].upcase,
               "eventsacked".to_sym   => !r.body.first['ack_author'].empty? }

    send_event("#{data_tag}_#{env}", retval)
  end

  monitors.each do |env, url1|
    c = JSONClient.new
    c.ssl_config.verify_mode = OpenSSL::SSL::VERIFY_NONE
    c.set_auth(url1, USERNAME, PASSWORD)
    c.force_basic_auth = true
    url = url1 + 'filter/count?format=json&query=%5Bhosts%5D%20state%20!%3D%200%20and%20state_type%20%3D%201'
    r = c.get(url)
    puts "url = #{url}, status = #{r.status}" unless r.status == 200
    next if r.nil? || r.status != 200
    err = r.body['count'].to_i
    url = url1 + 'filter/count?format=json&query=%5Bhosts%5D%20state%20%3D%200%20and%20state_type%20%3D%201'
    r = c.get(url)
    puts "url = #{url}, status = #{r.status}" unless r.status == 200
    next if r.nil? || r.status != 200
    ok =  r.body['count'].to_i
    url = url1 + 'filter/query?format=json&limit=1&query=%5Bnotifications%5D%20notification_type%20%3D%200'
    puts "url = #{url}, status = #{r.status}" unless r.status == 200
    r = c.get(url)
    next if r.nil? || r.status != 200
    servstat = format_time(Time.now - Time.at(r.body.first['end_time'].to_i)) unless r.body.first.nil?
    url = url1 + 'filter/count?format=json&query=%5Bservices%5D%20state%20!%3D%200'
    r = c.get(url)
    puts "url = #{url}, status = #{r.status}" unless r.status == 200
    next if r.nil? || r.status != 200
    services_not_ok = r.body['count'].to_i
    retval = {}
    retval["okhosts".to_sym] = ok
    retval["errhosts".to_sym] = err
    retval["servstathosts".to_sym] = services_not_ok
    retval["servfailhosts".to_sym] = servstat
    send_event("#{data_tag}_#{env}", retval)
  end


 monitors.each do |env, url1|
   c = JSONClient.new
   c.ssl_config.verify_mode = OpenSSL::SSL::VERIFY_NONE
   c.set_auth(url1, USERNAME, PASSWORD)
   c.force_basic_auth = true
   url = url1 + 'filter/count?format=json&query=%5Bservices%5D%20all'
   r = c.get(url)
   puts "url = #{url}, status = #{r.status}" unless r.status == 200
   next if r.nil? || r.status != 200
   all =  r.body['count'].to_i

   url = url1 + 'filter/count?format=json&query=%5Bservices%5D%20state%20%3D%200%20and%20state_type%20%3D%201'
   r = c.get(url)
   puts "url = #{url}, status = #{r.status}" unless r.status == 200
   next if r.nil? || r.status != 200
   ok =  r.body['count'].to_i


   url = url1 + 'filter/count?format=json&query=%5Bservices%5D%20state%20%3D%201%20and%20acknowledged%20%3D%201'
   r = c.get(url)
   puts "url = #{url}, status = #{r.status}" unless r.status == 200
   next if r.nil? || r.status != 200
   warn_ack =  r.body['count'].to_i

   url = url1 + 'filter/count?format=json&query=%5Bservices%5D%20state%20%3D%201%20and%20acknowledged%20%3D%200'
   r = c.get(url)
   puts "url = #{url}, status = #{r.status}" unless r.status == 200
   next if r.nil? || r.status != 200
   warn_noack =  r.body['count'].to_i


   url = url1 + 'filter/count?format=json&query=%5Bservices%5D%20state%20%3D%202%20and%20acknowledged%20%3D%201'
   r = c.get(url)
   puts "url = #{url}, status = #{r.status}" unless r.status == 200
   next if r.nil? || r.status != 200
   crit_ack =  r.body['count'].to_i

   url = url1 + 'filter/count?format=json&query=%5Bservices%5D%20state%20%3D%202%20and%20acknowledged%20%3D%200'
   r = c.get(url)
   puts "url = #{url}, status = #{r.status}" unless r.status == 200
   next if r.nil? || r.status != 200
   crit_noack =  r.body['count'].to_i

   retval = {}
   retval["crit_ack".to_sym] = crit_ack
   retval["warn_ack".to_sym] = warn_ack
   retval["crit_noack".to_sym] = crit_noack
   retval["warn_noack".to_sym] = warn_noack
   retval[:total] = all
   send_event("#{data_tag}_#{env}", retval)


   id = "op5servicesok_#{env}"
   url = url1 + 'filter/query?format=json&limit=1&query=%5Bnotifications%5D%20service_description%20~%20".%2B"'
   r = c.get(url)
   puts "url = #{url}, status = #{r.status}" unless r.status == 200
   next if r.nil? || r.status != 200
   servstat = format_time(Time.now - Time.at(r.body.first['end_time'].to_i))
   retval = {}
   retval["servicesok".to_sym] = ok
   retval[:total] = all
   retval["servicesoktime".to_sym] = servstat
   send_event("#{data_tag}_#{env}", retval)
 end
end
