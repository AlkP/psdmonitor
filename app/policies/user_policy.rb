class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def index?    ; user_is_admin?  ; end
  def edit?     ; user_is_admin?  ; end
  def update?   ; user_is_admin?  ; end
  def destroy?  ; user_is_admin?  && its_not_user_record? ; end
  def new?      ; user_is_admin?  ; end
  def create?   ; user_is_admin?  ; end

  private

  def user_is_admin?
    user.admin?
  end

  def its_not_user_record?
    record != user
  end
end
