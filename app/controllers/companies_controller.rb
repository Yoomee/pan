class CompaniesController < ApplicationController
  
  expose(:companies) {Company.order('name')}
  expose(:company)
  expose(:posts) {company.posts.page(params[:page])}

  def create
    if company.save
      flash[:notice] = 'Created new company'
      redirect_to(company)
    else
      render :action => 'new'
    end
  end

  def destroy
    company.destroy
    flash[:notice] = "Deleted company, #{company}"
    redirect_to(companies_path)
  end
  
  def edit
  end
  
  def index
  end
  
  def new
  end
  
  def show
    
  end
  
  def update
    if company.save
      flash[:notice] = 'updated company'
      redirect_to(company)
    else
      render :action => 'edit'
    end
  end
  
end