class PostPolicy
  attr_reader :user, :post

  def initialize(user, post)
    @user = user
    @post = post
  end

  def create?
    user.admin? || user.user?
  end

  def update?
    can_update_or_destroy?
  end

  def destroy?
    can_update_or_destroy?
  end

  private
  def can_update_or_destroy?
    return true if user.admin?
    return user.id == post.user_id if user.user?
    false
  end
end
