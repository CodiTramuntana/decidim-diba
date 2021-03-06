# This migration comes from decidim (originally 20170713131308)
# frozen_string_literal: true

class MigrateUserRolesToParticipatoryProcessRoles < ActiveRecord::Migration[5.1]
  class ParticipatoryProcess < ApplicationRecord
    self.table_name = :decidim_participatory_processes
  end

  class User < ApplicationRecord
    self.table_name = :decidim_users
  end

  def up
    participatory_processes = ParticipatoryProcess.all
    User.find_each do |user|
      next if user.roles.empty? || user.roles.include?('admin')

      processes = participatory_processes.select do |process|
        process.decidim_organization_id == user.decidim_organization_id
      end
      values = processes.map do |process|
        user.roles.map do |role|
          "(#{user.id}, #{process.id}, '#{role}', NOW(), NOW())"
        end
      end

      execute("
        INSERT INTO decidim_admin_participatory_process_user_roles
        (decidim_user_id, decidim_participatory_process_id, role, created_at, updated_at)
        VALUES #{values.join(', ')}
      ")
    end
    remove_column :decidim_users, :roles
  end
end
