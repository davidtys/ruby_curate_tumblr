class Hash
	def check_key( key, where='' )
    raise "no key '#{key}' in Hash #{to_s} #{where}" if !self.has_key?( key )
    raise "no key '#{key}' in Hash #{to_s} #{where}" if self[key].nil?
		raise "key '#{key}' is empty in Hash #{to_s} #{where}" if self[key].empty?
	end
end