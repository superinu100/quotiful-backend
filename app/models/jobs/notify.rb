module Jobs
	class Notify
    @queue = :notify

    # alert_type - accepts symbol of the following
    #   new_follower
    #   fb_friend_joins
    #   likes_your_post
    #   comments_on_your_post
    #   comments_after_you
    #   requotes_your_post
    #   tagged_in_post
    #   post_gets_featured
    # user_ids - accepts an integer or a comma-separated string of IDs
    # actor_id - accepts integer or string of ID
    def self.perform(alert_type, user_ids, actor_id)
      users = User.where(id: user_ids.split(','))

      users.each do |user|
        
        case alert_type
        when :new_follower
        when :fb_friend_joins
        when :likes_your_post
        when :comments_on_your_post
        when :comments_after_you
        when :requotes_your_post
          Activity.for_requotes_your_post_to(user.id, actor_id)
        when :tagged_in_post
          Activity.for_tagged_in_post_to(user.id, actor_id)
        when :tagged_in_comment
          Activity.for_tagged_in_comment_to(user.id, actor_id)
        when :post_gets_featured
        end

      end

    end
  end
end