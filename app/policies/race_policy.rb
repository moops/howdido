class RacePolicy < ApplicationPolicy
  # class scope
  class Scope < Scope
    def resolve
      # all races are public for now
      scope.all
    end
  end

  def index?
    # anyone can see the races
    true
  end

  def create?
    # must be logged in
    user
  end

  def update?
    # must be admin
    user.admin? if user
  end

  def destroy?
    # must be admin
    user.admin? if user
  end
end
