require 'test_helper'

class BooksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @book = books(:one)
    # Je créer un User pour obtenir un token d'accès unique
    @demo = User.create!({email: 'demo@demo.com', password: 'demodemo', password_confirmation: 'demodemo'})
  end

  test "should get index" do
    get books_url, as: :json
    assert_response :success
  end

  # Je dois ajouter le header 'Authorization'
   test "should create book" do
    assert_difference('Book.count') do
      post books_url,
           params: { book: { title: @book.title } },
           as: :json,
           headers: {'Authorization' => token_header(@demo.auth_token)}
    end

    assert_response 201
  end

  test "should show book" do
    get book_url(@book), as: :json
    assert_response :success
  end

  # Je dois ajouter le header 'Authorization'
  test "should update book" do
    patch book_url(@book),
          params: { book: { title: @book.title } },
          as: :json,
          headers: {'Authorization' => token_header(@demo.auth_token)}
    assert_response 200
  end

  # Sinon ça ne marche pas
  test "should not update book" do
    patch book_url(@book),
          params: { book: { title: @book.title } },
          as: :json
    assert_response 401
  end

  test "should destroy book" do
    assert_difference('Book.count', -1) do
      delete book_url(@book),
             as: :json,
             headers: {'Authorization' => token_header(@demo.auth_token)}
    end

    assert_response 204
  end
end
