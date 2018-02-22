//
//  Texts.swift
//  wftiles
//
//  Created by Kim Stephen Bovim on 20/02/2018.
//  Copyright © 2018 Kim Stephen Bovim. All rights reserved.
//

import Foundation

class Texts {
    static let shared = Texts()
    
    private var texts = [String: [String]]()
    private let locales = ["en", "nb", "nl", "da", "sv", "es", "fr", "de", "fi", "pt"]
    
    private func getLocaleIndex() -> Int {
        var preferredLanguage = NSLocale.preferredLanguages[0]
        if preferredLanguage.contains("-") {
            preferredLanguage = preferredLanguage.components(separatedBy: "-")[0]
        }
        guard let index = locales.index(of: preferredLanguage) else {
            return 0
        }
        return index
    }
    
    func getText(key: String) -> String {
        guard let textArray = texts[key] else {
            return "Missing text"
        }
        return textArray[getLocaleIndex()]
    }
    
    private init() {
        texts["usernameEmail"] = ["username/email", "brukernavn/e-post", "gebruikersnaam/e-mail", "brugernavn/e-mail", "användarnamn/e-post", "nombre de usuario/e-mail", "nom d'utilisateur/e-mail", "benutzername/e-mail", "käyttäjänimi/sähköposti", "nome de Usuário/e-mail"]
        
        texts["password"] = ["password", "passord", "wachtwoord", "adgangskode", "lösenord", "contraseña", "Mot de passe", "kennwort", "salasana", "senha"]
        
        texts["login"] = ["Log in", "Logg inn", "Inloggen", "Log på", "Logga inn", "Iniciar sesión", "Connexion", "Anmelden", "Kirjaudu", "Entrar"]
        
        texts["logout"] = ["Log out", "Logg ut", "Uitloggen", "Log af", "Logga ut", "Desconectarse", "Se déconnecter", "Abmelden", "Kirjaudu ulos", "Sair"]
        
        texts["yourTurn"] = ["Your turn", "Din tur", "Jouw beurt", "Din tur", "Din tur", "Te toca", "Ton tour", "Du bist dran", "Sinun vuorosi", "Sua Vez"]
        
        texts["opponentsTurn"] = ["Their turn", "Motstanders tur", "Hun beurt", "Deres tur", "Motspelarens tur", "Su turno", "Leur tour", "Der Gegner ist dran", "Vastustajan vuoro", "É a Vez Deles"]
        
        texts["finishedGames"] = ["Finished games", "Avsluttede spill", "Voltooide spellen", "Afsluttede spil", "Avslutade matcher", "Partidas terminadas", "Parties terminées", "Beendete Spiele", "Päättyneet pelit", "Jogos Finalizados"]
        
        texts["enlishUS"] = ["English game (US)", "Engelsk spill (amer.)", "Engels (VS) spel", "Spil på engelsk (USA)", "Engelsk match (amerikansk)", "Partida en inglés (EE.UU.)", "Partie en anglais (USA)", "Englisches Spiel (USA)", "Englanninkielinen peli (US)", "Jogo em inglês (EUA)"]
        
        texts["norwegianBokmal"] = ["Norwegian game (bokmål)", "Norsk spill (bokmål)", "Noors spel (bokmål)", "Spil på norsk (bokmål)", "Norsk match (bokmål)", "Partida en noruego (bokmål)", "Partie en norvégien (bokmål)", "Norwegisches Spiel (Bokmål)", "Norjankielinen peli (bokmål)", "Jogo em norueguês (bokmål)"]
        
        texts["dutch"] = ["Dutch game", "Nederlandsk spill", "Nederlands spel", "Spil på hollandsk", "Holländsk match", "Partida en holandés", "Partie en hollandais", "Niederländisches Spiel", "Hollanninkielinen peli", "Jogo em holandês"]
        
        texts["danish"] = ["Danish game", "Dansk spill", "Deens spel", "Spil på dansk", "Dansk match", "Partida en danés", "Partie en danois", "Dänisches Spiel", "Tanskankielinen peli", "Jogo em dinamarquês"]
        
        texts["swedish"] = ["Swedish game", "Svensk spill", "Zweeds spel", "Spil på svensk", "Svensk match", "Partida en sueco", "Partie en suédois", "Schwedisches Spiel", "Ruotsinkielinen peli", "Jogo em sueco"]
        
        texts["englishIntl"] = ["English game (Intl)", "Engelsk spill (int.)", "Engels (Intl) spel", "Spil på engelsk (intl.)", "Engelsk match (internationell)", "Partida en inglés (Int.)", "Partie en anglais (inter.)", "Englisches Spiel (int.)", "Englanninkielinen peli (kans.)", "Jogo em inglês (Inter)"]
        
        texts["spanish"] = ["Spanish game", "Spansk spill", "Spaans spel", "Spil på spansk", "Spansk match", "Partida en español", "Partie en espagnol", "Spanisches Spiel", "Espanjankielinen peli", "Jogo em espanhol"]
        
        texts["french"] = ["French game", "Fransk spill", "Frans spel", "Spil på fransk", "Fransk match", "Partida en francés", "Partie en français", "Französisches Spiel", "Ranskankielinen peli", "Jogo em francês"]
        
        texts["swedishStrict"] = ["Swedish game (strict)", "Svensk spill (strikt)", "Zweeds (strikt) spel", "Spil på svensk (eksakt)", "Svensk match (strikt)", "Partida en sueco (riguroso)", "Partie en suédois (strict)", "Schwedisches Spiel (strikt)", "Ruotsinkielinen peli (vain perusmuodot)", "Jogo em sueco (estrito)"]
        
        texts["german"] = ["German game", "Tysk spill", "Duits spel", "Spil på tysk", "Tysk match", "Partida en alemán", "Partie en allemand", "Deutsches Spiel", "Saksankielinen peli", "Jogo em alemão"]
        
        texts["norwegianNynorsk"] = ["Norwegian game (nynorsk)", "Norsk spill (nynorsk)", "Noors spel (nynorsk)", "Spil på norsk (nynorsk)", "Norsk match (nynorsk)", "Partida en noruego (nynorsk)", "Partie en norvégien (nynorsk)", "Norwegisches Spiel (Nynorsk)", "Norjankielinen peli (nynorsk)", "Jogo em norueguês (nynorsk)"]
        
        texts["finnish"] = ["Finnish game", "Finsk spill", "Fins spel", "Spil på finsk", "Finsk match", "Partida en finés", "Partie en finnois", "Finnisches Spiel", "Suomenkielinen peli", "Jogo em finlandês"]
        
        texts["portuguese"] = ["Portuguese game", "Portugisisk spill", "Portugees spel", "Spil på portugisisk", "Portugisisk match", "Partida en portugués", "Partie en portugais", "Portugiesisches Spiel", "Portugalinkielinen peli", "Jogo em português"]
        
        texts["youPlayed"] = ["You played %word% for %p% points", "Du la %word% for %p% poeng", "Je hebt %word% gelegd en %p% punten behaald", "Du spillede %word% for %p% point", "Du spelade %word% för %p% poäng", "Has puesto %word% por %p% puntos", "Tu as joué %word% pour %p% points", "Du hast %word% gespielt und %p% Punkte erzielt", "Pelasit sanan %word% ja sait %p% pistettä", "Você jogou %word% por %p% pontos"]
        
        texts["theyPlayed"] = ["%opp% played %word% for %p% points", "%opp% la %word% for %p% poeng", "%opp% heeft %word% gelegd en %p% punten behaald", "%opp% spillede %word% for %p% point", "%opp% spelade %word% för %p% poäng", "%opp% ha puesto %word% por %p% puntos", "%opp% a joué %word% pour %p% points", "%opp% hat %word% gespielt und %p% Punkte erzielt", "%opp% pelasi sanan %word% ja sai %p% pistettä", "%opp% jogou %word% por %p% pontos"]
        
        texts["youResigned"] = ["You resigned", "Du ga opp", "Je haakte af", "Du gav op", "Du gav upp", "Te has rendido", "Tu as abandonné", "Du hast aufgegeben", "Luovutit", "Você abandonou a partida"]
        
        texts["theyResigned"] = ["%opp% resigned", "%opp% ga opp", "%opp% haakte af", "%opp% gav op", "%opp% gav upp", "%opp% se ha rendido", "%opp% a abandonné", "%opp% hat aufgegeben", "%opp% luovutti", "%opp% abandonou"]
        
        texts["youPassed"] = ["You passed", "Du meldte pass", "Je hebt gepast", "Du meldte pas", "Du passade", "Has pasado", "Tu as passé", "Du hast gepasst", "Passasit", "Você passou"]
        
        texts["theyPassed"] = ["%opp% passed", "%opp% meldte pass", "%opp% paste", "%opp% meldte pas", "%opp% passade", "%opp% ha pasado", "%opp% a passé", "%opp% passt", "%opp% passasi", "%opp% passou"]
        
        texts["youSwapped"] = ["You swapped %count% tiles", "Du byttet %count% brikker", "Je hebt %count% letters geruild", "Du byttede %count% brikker", "Du bytte ut %count% brickor", "Has cambiado %count% fichas", "Tu as échangé %count% pièces", "Du hast %count% Spielsteine getauscht", "Vaihdoit %count% laattaa", "Você trocou %count% peças"]
        
        texts["youSwappedOne"] = ["You swapped %count% tile", "Du byttet %count% brikke", "Je hebt %count% letter geruild", "Du byttede %count% brikke", "Du bytte ut %count% bricka", "Has cambiado %count% ficha", "Tu as échangé %count% pièce", "Du hast %count% Spielstein getauscht", "Vaihdoit %count% laatan", "Você trocou %count% peça"]
        
        texts["theySwapped"] = ["%opp% swapped %count% tiles", "%opp% byttet %count% brikker", "%opp% heeft %count% letters geruild", "%opp% byttede %count% brikker", "%opp% bytte ut %count% brickor", "%opp% ha cambiado %count% fichas", "%opp% a échangé %count% pièces", "%opp% hat %count% Spielsteine getauscht", "%opp% vaihtoi %count% laattaa", "%opp% trocou %count% peças"]
        
        texts["theySwappedOne"] = ["%opp% swapped %count% tile", "%opp% byttet %count% brikke", "%opp% heeft %count% letter geruild", "%opp% byttede %count% brikke", "%opp% bytte ut %count% bricka", "%opp% ha cambiado %count% ficha", "%opp% a échangé %count% pièce", "%opp% hat %count% Spielstein getauscht", "%opp% vaihtoi %count% laatan", "%opp% trocou %count% peça"]
        
        texts["firstMoveYou"] = ["It's your turn against %opp%", "Det er din tur mot %opp%", "Het is jouw beurt tegen %opp%", "Det er din tur mod %opp%", "Det är din tur mot %opp%", "Te toca jugar contra %opp%", "C'est ton tour contre %opp%", "Du bist dran gegen %opp%", "%opp% odottaa - on sinun vuorosi", "É sua vez contra %opp%"]
        
        texts["firstMoveThem"] = ["Waiting for %opp% to make a move", "Venter på et trekk fra %opp%", "Wacht op een zet van %opp%", "Venter på, at %opp% foretager et træk", "Vänter på att %opp% ska göra ett drag", "Esperando a que %opp% mueva ficha", "En attente d'un coup de %opp%", "Warten auf Zug von %opp%", "Odotetaan, että %opp% tekee siirtonsa", "Esperando que %opp% faça um movimento"]
        
        texts["yourTiles"] = ["Your tiles", "Dine brikker", "Jouw letters", "Dine brikker", "Dina brickor", "Tus fichas", "Vos pièces", "Deine Spielsteine", "Teidän laatat", "Suas peças"]
        
        texts["remainingTiles"] = ["Remaining tiles", "Resterende brikker", "Resterende letters", "Resterende brikker", "Resterande brickor", "Fichas restantes", "Pièces restantes", "Verbleibende Spielsteine", "Jäljellä olevat laatat", "Peças restantes"]
        
        texts["standard"] = ["Standard", "Standard", "Standaard", "Standard", "Standard", "Estándar", "Standard", "Standard", "Vakio", "Padrão"]
        
        texts["overview"] = ["Overview", "Oversikt", "Overzicht", "Oversigt", "Översikt", "Visión de conjunto", "Vue d'ensemble", "Überblick", "Yleiskatsaus", "Visão global"]
        
        texts["alphabetical"] = ["Alphabetical", "Alfabetisk", "Alfabetisch", "Alfabetisk", "Alfabetisk", "Alfabético", "Alphabétique", "Alphabetisch", "Aakkosellinen", "Alfabeticamente"]
        
        texts["vowelConsonant"] = ["Vowels/consonants", "Vokaler/konsonanter", "Klinkers/medeklinkers", "Vokaler/konsonanter", "Vokaler/konsonanter", "Vocales/consonantes", "Voyelles/consonnes", "Vokale/Konsonanten", "Vokaalit/konsonantteja", "Vogais/consoantes"]
        
        texts["loggingIn"] = ["Logging in...", "Logger inn...", "Logt aan...", "Logger på...", "Loggar in...", "Iniciando sesión...", "Connexion en cours...", "Login läuft...", "Kirjaudutaan...", "Entrando..."]
        
        texts["loginFailed"] = ["Login failed", "Innlogging feilet", "Aanmelden mislukt", "Login mislykkedes", "Inloggningen misslyckades", "Error de inicio de sesion", "Échec de la connexion", "Anmeldung fehlgeschlagen", "Kirjautuminen epäonnistui", "Falha na autenticação"]
        
        texts["pleaseWait"] = ["Please wait...", "Vennligst vent...", "Even wachten...", "Vent et øjeblik...", "Vänligen vänta...", "Un momento, por favor", "Un instant...", "Bitte warte...", "Odota", "Por favor, aguarde..."]
        
        texts["loadingFailed"] = ["Loading failed", "Lasting feilet", "Laden mislukt", "Loading mislykkedes", "Hämtningen misslyckades", "La descarga falló", "Chargement échoué", "Laden fehlgeschlagen", "Lataus epäonnistui", "O carregamento falhou"]
        
        texts["connectionError"] = ["Connection error", "Feil ved oppkobling", "Verbindingsfout", "Forbindelsesfejl", "Anslutningsfel", "Error de conexión", "Erreur de connexion", "Verbindungsfehler", "Yhteysvirhe", "Erro de Conexão"]
        
        texts["unknownEmail"] = ["Unknown email", "Ukjent e-post", "Onbekende gebruiker", "Ukendt bruger", "Okänd användare", "Dirección de correo electrónico incorrecta", "Utilisateur inconnu", "Unbekannter Benutzer", "Tuntematon käyttäjä", "Usuário Desconhecido"]
        
        texts["unknownUsername"] = ["Unknown username", "Ukjent brukernavn", "Onbekende gebruiker", "Ukendt bruger", "Okänd användare", "Usuario desconocido", "Utilisateur inconnu", "Unbekannter Benutzer", "Tuntematon käyttäjä", "Usuário Desconhecido"]
        
        texts["wrongPassword"] = ["Wrong password", "Feil passord", "Wachtwoord onjuist", "Forkert adgangskode", "Ogiltigt lösenord", "Contraseña incorrecta", "Mot de passe erroné", "Falsches Passwort", "Virheellinen salasana", "Senha incorreta"]
        
        texts["ok"] = ["OK", "OK", "Oké", "OK", "OK", "Aceptar", "OK", "OK", "OK", "Ok"]
        
    }
}
