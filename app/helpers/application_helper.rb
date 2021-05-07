module ApplicationHelper
  def tel_to text
    groups = text.to_s.scan(/(?:^\+)?\d+/)
    if groups.size > 1 && groups[0][0] == '+'
      groups[1] = groups[1][1..-1] if groups[1][0] == '0'
      groups.delete_at(1) if groups[1].size == 0
    end
    link_to text, "tel:#{groups.join '-'}"
  end

end
