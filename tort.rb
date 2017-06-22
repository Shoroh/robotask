tort = 100
tort_piece = {}
party = (1..100).each_with_object({}) do |guest, party|
  next if guest == 0
  party[guest] = (guest * tort.to_f) / 100.0
  puts "Guest ##{guest} gets #{party[guest]} of #{tort}"
  tort_piece[guest] = tort
  tort = tort - party[guest]
end

#.sort_by{|k, v| v}

party.each do |k, v|
  puts tort_piece[k]
end
