module CompaniesHelper
    def company_creator?(current_user)
        current_user.id == @company.creator_id if current_user
    end
    def belong_to_company?(current_user, company.id)
        current_user.companies.each do |users_company|
            if users_company.id == company.id 
                company.id
            end
        end
    end
end
