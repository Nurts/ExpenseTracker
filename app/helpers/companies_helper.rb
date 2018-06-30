module CompaniesHelper
    def company_creator?(current_user)
        current_user.id == @company.creator_id if current_user
    end
end
