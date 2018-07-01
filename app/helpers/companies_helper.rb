module CompaniesHelper
    def company_creator?(current_user)
        current_user.id == @company.creator_id if current_user
    end

    def compute_total_cost_day(company, time)
        sum = 0
        company.categories.each do |category|
            category.posts.each do |post|
                if time-post.created_at < 86400 
                    sum += post.expense
                end
            end
        end
        return sum
    end

    def compute_cost_day(category, time)
        sum = 0
        category.posts.each do |post|
            if time-post.created_at < 86400 
                sum += post.expense
            end
        end
        return sum
    end

    def compute_total_cost_week(company, time)
        sum = 0
        company.categories.each do |category|
            category.posts.each do |post|
                if time-post.created_at < 604800 
                    sum += post.expense
                end
            end
        end
        return sum
    end

    def compute_cost_week(category, time)
        sum = 0
        category.posts.each do |post|
            if time-post.created_at < 604800 
                sum += post.expense
            end
        end
        return sum
    end

    def compute_cost_month(category, time)
        sum = 0
        category.posts.each do |post|
            if time-post.created_at < 18144000 
                sum += post.expense
            end
        end
        return sum
    end

    def compute_total_cost_month(company, time)
        sum = 0
        company.categories.each do |category|
            category.posts.each do |post|
                if time-post.created_at < 18144000
                    sum += post.expense
                end
            end
        end
        return sum
    end
    
end
