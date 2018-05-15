# frozen_string_literal: true

module Decidim
  module Census
    module Abilities
      # Defines the abilities related to census upload for a logged in admin user.
      # Intended to be used with `cancancan`.
      class AdminAbility < Decidim::Abilities::AdminAbility

        def define_abilities
          super
          can :manage, Decidim::Census::CensusDatum
        end

      end
    end
  end
end
