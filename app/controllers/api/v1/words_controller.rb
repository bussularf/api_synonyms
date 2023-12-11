module Api
  module V1
    class WordsController < ApplicationController
      def index
        words_and_synonyms = Word.includes(:synonyms)
                                 .where('words.id = synonyms.word_id AND synonyms.status = 1')
                                 .pluck('words.reference AS word, synonyms.reference AS synonym')

        result = words_and_synonyms.map { |ws| { word: ws[0], synonym: ws[1] } }
        render json: result
      end

      def create_synonym_and_word
        word = Word.find_or_create_by(reference: params[:reference])

        existing_synonym = word.synonyms.find_by(reference: params[:synonym])

        if existing_synonym
          render json: { error: 'Synonym already exists for this word.' }, status: :unprocessable_entity
        else
          synonym = word.synonyms.create(reference: params[:synonym])
          render json: { word: word.reference, synonym: synonym.reference }, status: :created
        end
      end

      def search_synonyms
        words_and_synonyms = load_synonyms

        if words_and_synonyms.present?
          render_synonyms_result(words_and_synonyms)
        else
          render_not_found_error('No synonyms found for this word.')
        end
      end

      def unreviewed_synonyms
        all_unreviewed_synonyms = Synonym.includes(:word).where(status: 0)

        if all_unreviewed_synonyms.present?
          render_synonyms_result(all_unreviewed_synonyms)
        else
          render_not_found_error('No unreviewed synonyms found for any word.')
        end
      end

      def authorize_synonym
        synonym = Synonym.find_by(reference: params[:synonym], status: 0)

        if synonym.present?
          synonym.update(status: 1)
          render json: { message: 'Synonym authorized successfully.' }, status: :ok
        else
          render json: { error: 'No unreviewed synonym found for this word' }, status: :not_found
        end
      end

      def delete_synonym
        word = Word.find_by(reference: params[:reference])
        synonym = Synonym.find_by(reference: params[:synonym], word_id: word.id)

        if synonym.present?
          synonym.destroy
          render json: { message: 'Synonym deleted successfully.' }, status: :ok
        else
          render json: { error: 'Synonym not found for this word.' }, status: :not_found
        end
      end

      private

      def group_synonyms_by_word(synonyms)
        synonyms.group_by { |synonym| synonym.word.reference }.transform_values { |synonyms| { synonyms: synonyms.pluck(:reference) } }
      end

      def load_synonyms
        if @current_user&.admin?
          Synonym.includes(:word).where(words: { reference: params[:reference] })
        else
          Synonym.includes(:word).where(words: { reference: params[:reference] }, synonyms: { status: 1 })
        end
      end

      def render_synonyms_result(synonyms)
        result = group_synonyms_by_word(synonyms)
        render json: result, status: :ok
      end

      def render_not_found_error(message)
        render json: { error: message }, status: :not_found
      end
    end
  end
end
