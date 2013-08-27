class Hash
	def check_key( key )
    raise "no key '#{key}' in Hash #{to_s}" if !self.has_key?( key )
    raise "no key '#{key}' in Hash #{to_s}" if self[key].nil?
		raise "key '#{key}' is empty in Hash #{to_s}" if self[key].empty?
	end
end