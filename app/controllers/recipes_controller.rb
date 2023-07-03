class RecipesController < ApplicationController
  def index
    if session.include?(:user_id)
      recipes = Recipe.all

      render json: recipes.to_json(except: [:created_at, :updated_at], include: [user: { except:[:created_at, :updated_at]}]), status: :ok
    else
      render json: { errors: ["Unauthorized"] }, status: :unauthorized
    end
  end

  def create
    if session[:user_id]
      user = User.find(session[:user_id])
      recipe = user.recipes.build(recipe_params)

      if recipe.save
        render json: recipe.to_json(except: [:created_at, :updated_at], include: [user: { except:[:created_at, :updated_at]}]), status: :created
      else
        render json: { errors: recipe.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { errors: ["Unauthorized"] }, status: :unauthorized
    end
  end

  private

  def recipe_params
    params.permit(:title, :instructions, :minutes_to_complete)
  end
end
