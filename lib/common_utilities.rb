module CommonUtilities
  def strip_trailing_zero(n)
    n.to_s.sub(/\.?0+$/, '')
  end
end