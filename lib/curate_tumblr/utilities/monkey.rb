class Hash
	def check_key( key )
		raise "'#{key}' is empty in #{to_s}" if self[key].empty?
	end
end