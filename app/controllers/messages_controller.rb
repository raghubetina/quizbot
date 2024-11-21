class MessagesController < ApplicationController
  def index
    matching_messages = Message.all

    @list_of_messages = matching_messages.order({ :created_at => :desc })

    render({ :template => "messages/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_messages = Message.where({ :id => the_id })

    @the_message = matching_messages.at(0)

    render({ :template => "messages/show" })
  end

  def create
    the_message = Message.new
    the_message.role = "user"
    the_message.content = params.fetch("query_content")
    the_message.quiz_id = params.fetch("query_quiz_id")

    if the_message.valid?
      the_message.save

      # Get the next message from GPT

      message_list = Array.new

      the_quiz = Quiz.where(id: the_message.quiz_id).first

      the_quiz.messages.order(:created_at).each do |a_message|
        hash_version = {
          "role" => a_message.role,
          "content" => a_message.content,
        }

        message_list.push(hash_version)
      end

      client = OpenAI::Client.new(access_token: ENV.fetch("OPENAI_API_KEY"))

      # Call the API to get the next message from GPT
      api_response = client.chat(
        parameters: {
          model: "gpt-3.5-turbo",
          messages: message_list,
        },
      )

      assistant_content = api_response.fetch("choices").at(0).fetch("message").fetch("content")

      assistant_message = Message.new
      assistant_message.role = "assistant"
      assistant_message.quiz_id = the_quiz.id
      assistant_message.content = assistant_content

      assistant_message.save

      redirect_to("/quizzes/#{the_message.quiz_id}", { :notice => "Message created successfully." })
    else
      redirect_to("/messages", { :alert => the_message.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_message = Message.where({ :id => the_id }).at(0)

    the_message.role = params.fetch("query_role")
    the_message.content = params.fetch("query_content")
    the_message.quiz_id = params.fetch("query_quiz_id")

    if the_message.valid?
      the_message.save
      redirect_to("/messages/#{the_message.id}", { :notice => "Message updated successfully."} )
    else
      redirect_to("/messages/#{the_message.id}", { :alert => the_message.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_message = Message.where({ :id => the_id }).at(0)

    the_message.destroy

    redirect_to("/messages", { :notice => "Message deleted successfully."} )
  end
end
