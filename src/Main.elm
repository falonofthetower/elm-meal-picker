module Main exposing (Meal, Model, Msg(..), init, main, update, view)

import Browser
import Html exposing (Html, div, h1, h2, img, li, text, ul)
import Html.Attributes exposing (src)
import Html.Events exposing (onClick)
import List.Extra exposing (remove)



---- MODEL ----


type alias Model =
    { choices : List Meal, selected : List Meal }


currentList =
    [ Meal "Bean Burritos"
    , Meal "Soup"
    , Meal "Chili"
    , Meal "Herbed Potatoes"
    , Meal "Baked Potatoes"
    , Meal "Jambalaya"
    , Meal "Fried Rice"
    , Meal "Peanut Noodles"
    , Meal "Stir Fry"
    , Meal "Pasta"
    ]


init : ( Model, Cmd Msg )
init =
    ( { choices = currentList, selected = [] }, Cmd.none )



---- UPDATE ----


type alias Meal =
    { name : String }


type AddRemove
    = Add
    | Remove


type Msg
    = NoOp
    | AddMeal Meal
    | RemoveMeal Meal


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AddMeal meal ->
            ( { model
                | choices = remove meal model.choices
                , selected = meal :: model.selected
              }
            , Cmd.none
            )

        RemoveMeal meal ->
            ( { model
                | selected = remove meal model.selected
                , choices = meal :: model.choices
              }
            , Cmd.none
            )

        NoOp ->
            ( model, Cmd.none )


liMeal : AddRemove -> Meal -> Html Msg
liMeal cmd meal =
    let
        command =
            case cmd of
                Add ->
                    AddMeal

                Remove ->
                    RemoveMeal
    in
    li [ onClick (command meal) ] [ text meal.name ]



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ img [ src "/logo.svg" ] []
        , h1 [] [ text "What shall we eat today?" ]
        , h2 [] [ text "Meal Choices" ]
        , ul [] (List.map (\l -> liMeal Add l) model.choices)
        , h2 [] [ text "On the Menu" ]
        , ul [] (List.map (\l -> liMeal Remove l) model.selected)
        ]



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
