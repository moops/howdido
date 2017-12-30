class ParticipationPolicy < ApplicationPolicy
  # class scope
  class Scope < Scope
    def resolve
      if user
        if user.admin?
          scope.all
        else
          scope.where('user_id = ? or private_key is null', user.id)
        end
      else
        scope.where(private_key: nil)
      end
    end
  end

  def index?
    true
  end

  def show?
    # admin or public gallery or gallery owner
    record.private_key.nil? || (user && user.admin?) || (user && user.id == record.user.id)
  end

  def create?
    # must be logged in
    user
  end

  def update?
    # must be admin or own the gallery
    user.admin? || user.id == record.user.id if user
  end

  def destroy?
    # must be admin or own the gallery
    user.admin? || user.id == record.user.id if user
  end

  def count?
    # must be admin or own the gallery
    user.admin? || user.id == record.user.id if user
  end
end
