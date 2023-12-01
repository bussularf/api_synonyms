module Api
  module V1
    class WordsController < ApplicationController
      def index
        words_and_synonyms = Word.joins(:synonyms)
          .where('words.id = synonyms.word_id AND synonyms.status = 1')
          .pluck('words.reference AS word, synonyms.reference AS synonym')

        result = words_and_synonyms.map { |ws| { word: ws[0], synonym: ws[1] } }
        render json: result
      end

      def create_synonym_and_word
        word = Word.find_by(reference: params[:reference])

        if word.nil?
          word = Word.create(reference:  params[:reference])
          synonym = Synonym.create(reference: params[:synonym], word_id: word.id)
          render json: { word: word.reference, synonym: synonym.reference }, status: :created

        else
          synonym = word.synonyms.find_by(reference: params[:synonym])

          if synonym.nil?
            synonym = Synonym.create(reference: params[:synonym], word_id: word.id)
            render json: { word: word.reference, synonym: synonym.reference }, status: :created
          else
            render json: { error: 'Synonym already exists for this word.' }, status: :unprocessable_entity
          end
        end
      end

      def get_unreviewed_synonyms
        all_unreviewed_synonyms = Synonym.where(status: 0).includes(:word)

        if all_unreviewed_synonyms.present?
          result = all_unreviewed_synonyms.group_by { |synonym| synonym.word.reference }.transform_values do |synonyms|
            {
              unreviewed_synonyms: synonyms.pluck(:reference)
            }
          end

          render json: result, status: :ok
        else
          render json: { error: 'No unreviewed synonyms found for any word.' }, status: :not_found
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

      def word_params
        params.require(:word).permit(:reference)
      end
    end
  end
end
