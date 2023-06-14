class Tenant < ApplicationRecord
  after_create :create_apartment_tenant

  def create_apartment_tenant
    Apartment::Tenant.create(subdomain)
  end

end
