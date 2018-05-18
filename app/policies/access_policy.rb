class AccessPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?   ; user_is_admin?  ; end
  def destroy?  ; user_is_admin? && self_admin_role? ; end

  private

  def user_is_admin?
    user.admin?
  end

  def self_admin_role?
    record.user != user || (record.user == user && record.role != 'admin')
  end
end
