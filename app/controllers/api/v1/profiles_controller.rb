class Api::V1::ProfilesController < Api::V1::BaseController
  def me
    render json: current_resource_owner, serializer: ProfileSerializer
  end

  def index
    @profiles = User.where.not(id: current_resource_owner.id)
    render json: @profiles, serializer_each: ProfileSerializer
  end
end
