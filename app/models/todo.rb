class Todo < ApplicationRecord
    belongs_to :user
    
    before_save :downcase_fields
    # after_initialize :init

    # def init
    #     self.done ||= false
    # end
    
    def downcase_fields
        self.tag.downcase
    end

end
