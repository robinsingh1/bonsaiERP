require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by the Rails when you ran the scaffold generator.

describe InventoryOperationsController do

  def mock_inventory_operation(stubs={})
    @mock_inventory_operation ||= mock_model(InventoryOperation, stubs).as_null_object
  end

  describe "GET index" do
    it "assigns all inventory_operations as @inventory_operations" do
      InventoryOperation.stub(:all) { [mock_inventory_operation] }
      get :index
      assigns(:inventory_operations).should eq([mock_inventory_operation])
    end
  end

  describe "GET show" do
    it "assigns the requested inventory_operation as @inventory_operation" do
      InventoryOperation.stub(:find).with("37") { mock_inventory_operation }
      get :show, :id => "37"
      assigns(:inventory_operation).should be(mock_inventory_operation)
    end
  end

  describe "GET new" do
    it "assigns a new inventory_operation as @inventory_operation" do
      InventoryOperation.stub(:new) { mock_inventory_operation }
      get :new
      assigns(:inventory_operation).should be(mock_inventory_operation)
    end
  end

  describe "GET edit" do
    it "assigns the requested inventory_operation as @inventory_operation" do
      InventoryOperation.stub(:find).with("37") { mock_inventory_operation }
      get :edit, :id => "37"
      assigns(:inventory_operation).should be(mock_inventory_operation)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "assigns a newly created inventory_operation as @inventory_operation" do
        InventoryOperation.stub(:new).with({'these' => 'params'}) { mock_inventory_operation(:save => true) }
        post :create, :inventory_operation => {'these' => 'params'}
        assigns(:inventory_operation).should be(mock_inventory_operation)
      end

      it "redirects to the created inventory_operation" do
        InventoryOperation.stub(:new) { mock_inventory_operation(:save => true) }
        post :create, :inventory_operation => {}
        response.should redirect_to(inventory_operation_url(mock_inventory_operation))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved inventory_operation as @inventory_operation" do
        InventoryOperation.stub(:new).with({'these' => 'params'}) { mock_inventory_operation(:save => false) }
        post :create, :inventory_operation => {'these' => 'params'}
        assigns(:inventory_operation).should be(mock_inventory_operation)
      end

      it "re-renders the 'new' template" do
        InventoryOperation.stub(:new) { mock_inventory_operation(:save => false) }
        post :create, :inventory_operation => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested inventory_operation" do
        InventoryOperation.stub(:find).with("37") { mock_inventory_operation }
        mock_inventory_operation.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :inventory_operation => {'these' => 'params'}
      end

      it "assigns the requested inventory_operation as @inventory_operation" do
        InventoryOperation.stub(:find) { mock_inventory_operation(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:inventory_operation).should be(mock_inventory_operation)
      end

      it "redirects to the inventory_operation" do
        InventoryOperation.stub(:find) { mock_inventory_operation(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(inventory_operation_url(mock_inventory_operation))
      end
    end

    describe "with invalid params" do
      it "assigns the inventory_operation as @inventory_operation" do
        InventoryOperation.stub(:find) { mock_inventory_operation(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:inventory_operation).should be(mock_inventory_operation)
      end

      it "re-renders the 'edit' template" do
        InventoryOperation.stub(:find) { mock_inventory_operation(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested inventory_operation" do
      InventoryOperation.stub(:find).with("37") { mock_inventory_operation }
      mock_inventory_operation.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the inventory_operations list" do
      InventoryOperation.stub(:find) { mock_inventory_operation }
      delete :destroy, :id => "1"
      response.should redirect_to(inventory_operations_url)
    end
  end

end