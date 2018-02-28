//
//  Texts.swift
//  wftiles
//
//  Created by Kim Stephen Bovim on 20/02/2018.
//  Copyright © 2018 Kim Stephen Bovim. All rights reserved.
//

import Foundation
import UIKit

class Texts {
    static let shared = Texts()
    
    private var texts = [String: [String]]()
    private let locales = ["en", "nb", "nl", "da", "sv", "es", "fr", "de", "fi", "pt"]
    private let languages = ["englishUS", "norwegianBokmal", "dutch", "danish", "swedish", "englishIntl", "spanish", "french", "swedishStrict",
                             "german", "norwegianNynorsk", "finnish", "portuguese"]
    
    func getMaxFontSize(text: String, maxWidth: CGFloat) -> CGFloat {
        var fontSize = 17
        while (fontSize > 10 && getTextWidth(text: text, font: UIFont.systemFont(ofSize: CGFloat(fontSize))) > maxWidth) {
            fontSize -= 1
        }
        return CGFloat(fontSize)
    }
    
    func getText(key: String) -> String {
        guard let textArray = texts[key] else {
            return "Missing text"
        }
        return textArray[getLocaleIndex()]
    }
    
    func getGameLanguage(ruleset: Int) -> String {
        if ruleset >= languages.count {
            return getText(key: "unsupportedLamguage")
        }
        return getText(key: languages[ruleset])
    }
    
    func getTextWidth(text: String, font: UIFont) -> CGFloat {
        let attributes = [NSAttributedStringKey.font: font]
        return text.size(withAttributes: attributes as Any as? [NSAttributedStringKey : Any]).width
    }
    
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
    
    private init() {
        texts["usernameEmail"] = ["username/email", "brukernavn/e-post", "gebruikersnaam/e-mail", "brugernavn/e-mail", "användarnamn/e-post", "nombre de usuario/e-mail", "nom d'utilisateur/e-mail", "benutzername/e-mail", "käyttäjänimi/sähköposti", "nome de Usuário/e-mail"]
        
        texts["password"] = ["password", "passord", "wachtwoord", "adgangskode", "lösenord", "contraseña", "Mot de passe", "kennwort", "salasana", "senha"]
        
        texts["login"] = ["Log in", "Logg inn", "Inloggen", "Log på", "Logga inn", "Iniciar sesión", "Connexion", "Anmelden", "Kirjaudu", "Entrar"]
        
        texts["logout"] = ["Log out", "Logg ut", "Uitloggen", "Log af", "Logga ut", "Desconectarse", "Se déconnecter", "Abmelden", "Kirjaudu ulos", "Sair"]
        
        texts["yourTurn"] = ["Your turn", "Din tur", "Jouw beurt", "Din tur", "Din tur", "Te toca", "Ton tour", "Du bist dran", "Sinun vuorosi", "Sua Vez"]
        
        texts["opponentsTurn"] = ["Their turn", "Motstanders tur", "Hun beurt", "Deres tur", "Motspelarens tur", "Su turno", "Leur tour", "Der Gegner ist dran", "Vastustajan vuoro", "É a Vez Deles"]
        
        texts["finishedGames"] = ["Finished games", "Avsluttede spill", "Voltooide spellen", "Afsluttede spil", "Avslutade matcher", "Partidas terminadas", "Parties terminées", "Beendete Spiele", "Päättyneet pelit", "Jogos Finalizados"]
        
        texts["englishUS"] = ["English game (US)", "Engelsk spill (amer.)", "Engels (VS) spel", "Spil på engelsk (USA)", "Engelsk match (amerikansk)", "Partida en inglés (EE.UU.)", "Partie en anglais (USA)", "Englisches Spiel (USA)", "Englanninkielinen peli (US)", "Jogo em inglês (EUA)"]
        
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
        
        texts["youPlayed"] = ["You played %@ for %d points", "Du la %@ for %d poeng", "Je hebt %@ gelegd en %d punten behaald", "Du spillede %@ for %d point", "Du spelade %@ för %d poäng", "Has puesto %@ por %d puntos", "Tu as joué %@ pour %d points", "Du hast %@ gespielt und %d Punkte erzielt", "Pelasit sanan %@ ja sait %d pistettä", "Você jogou %@ por %d pontos"]
        
        texts["theyPlayed"] = ["%@ played %@ for %d points", "%@ la %@ for %d poeng", "%@ heeft %@ gelegd en %d punten behaald", "%@ spillede %@ for %d point", "%@ spelade %@ för %d poäng", "%@ ha puesto %@ por %d puntos", "%@ a joué %@ pour %d points", "%@ hat %@ gespielt und %d Punkte erzielt", "%@ pelasi sanan %@ ja sai %d pistettä", "%@ jogou %@ por %d pontos"]
        
        texts["youResigned"] = ["You resigned", "Du ga opp", "Je haakte af", "Du gav op", "Du gav upp", "Te has rendido", "Tu as abandonné", "Du hast aufgegeben", "Luovutit", "Você abandonou a partida"]
        
        texts["theyResigned"] = ["%@ resigned", "%@ ga opp", "%@ haakte af", "%@ gav op", "%@ gav upp", "%@ se ha rendido", "%@ a abandonné", "%@ hat aufgegeben", "%@ luovutti", "%@ abandonou"]
        
        texts["youPassed"] = ["You passed", "Du meldte pass", "Je hebt gepast", "Du meldte pas", "Du passade", "Has pasado", "Tu as passé", "Du hast gepasst", "Passasit", "Você passou"]
        
        texts["theyPassed"] = ["%@ passed", "%@ meldte pass", "%@ paste", "%@ meldte pas", "%@ passade", "%@ ha pasado", "%@ a passé", "%@ passt", "%@ passasi", "%@ passou"]
        
        texts["youSwapped"] = ["You swapped %d tiles", "Du byttet %d brikker", "Je hebt %d letters geruild", "Du byttede %d brikker", "Du bytte ut %d brickor", "Has cambiado %d fichas", "Tu as échangé %d pièces", "Du hast %d Spielsteine getauscht", "Vaihdoit %d laattaa", "Você trocou %d peças"]
        
        texts["youSwappedOne"] = ["You swapped %d tile", "Du byttet %d brikke", "Je hebt %d letter geruild", "Du byttede %d brikke", "Du bytte ut %d bricka", "Has cambiado %d ficha", "Tu as échangé %d pièce", "Du hast %d Spielstein getauscht", "Vaihdoit %d laatan", "Você trocou %d peça"]
        
        texts["theySwapped"] = ["%@ swapped %d tiles", "%@ byttet %d brikker", "%@ heeft %d letters geruild", "%@ byttede %d brikker", "%@ bytte ut %d brickor", "%@ ha cambiado %d fichas", "%@ a échangé %d pièces", "%@ hat %d Spielsteine getauscht", "%@ vaihtoi %d laattaa", "%@ trocou %d peças"]
        
        texts["theySwappedOne"] = ["%@ swapped %d tile", "%@ byttet %d brikke", "%@ heeft %d letter geruild", "%@ byttede %d brikke", "%@ bytte ut %d bricka", "%@ ha cambiado %d ficha", "%@ a échangé %d pièce", "%@ hat %d Spielstein getauscht", "%@ vaihtoi %d laatan", "%@ trocou %d peça"]
        
        texts["firstMoveYou"] = ["It's your turn against %@", "Det er din tur mot %@", "Het is jouw beurt tegen %@", "Det er din tur mod %@", "Det är din tur mot %@", "Te toca jugar contra %@", "C'est ton tour contre %@", "Du bist dran gegen %@", "%@ odottaa - on sinun vuorosi", "É sua vez contra %@"]
        
        texts["firstMoveThem"] = ["Waiting for %@ to make a move", "Venter på et trekk fra %@", "Wacht op een zet van %@", "Venter på, at %@ foretager et træk", "Vänter på att %@ ska göra ett drag", "Esperando a que %@ mueva ficha", "En attente d'un coup de %@", "Warten auf Zug von %@", "Odotetaan, että %@ tekee siirtonsa", "Esperando que %@ faça um movimento"]
        
        texts["yourTiles"] = ["Your tiles", "Dine brikker", "Jouw letters", "Dine brikker", "Dina brickor", "Tus fichas", "Vos pièces", "Deine Spielsteine", "Teidän laatat", "Suas peças"]
        
        texts["remainingTiles"] = ["Remaining tiles", "Resterende brikker", "Resterende letters", "Resterende brikker", "Resterande brickor", "Fichas restantes", "Pièces restantes", "Verbleibende Spielsteine", "Jäljellä olevat laatat", "Peças restantes"]
        
        texts["standard"] = ["Standard", "Standard", "Standaard", "Standard", "Standard", "Estándar", "Standard", "Standard", "Vakio", "Padrão"]
        
        texts["overview"] = ["Overview", "Oversikt", "Overzicht", "Oversigt", "Översikt", "Visión de conjunto", "Vue d'ensemble", "Überblick", "Yleiskatsaus", "Visão global"]
        
        texts["alphabetical"] = ["Alphabetical", "Alfabetisk", "Alfabetisch", "Alfabetisk", "Alfabetisk", "Alfabético", "Alphabétique", "Alphabetisch", "Aakkosellinen", "Alfabeticamente"]
        
        texts["vowelsConsonants"] = ["Vowels/consonants", "Vokaler/konsonanter", "Klinkers/medeklinkers", "Vokaler/konsonanter", "Vokaler/konsonanter", "Vocales/consonantes", "Voyelles/consonnes", "Vokale/Konsonanten", "Vokaalit/konsonantteja", "Vogais/consoantes"]
        
        texts["loggingIn"] = ["Logging in...", "Logger inn...", "Logt aan...", "Logger på...", "Loggar in...", "Iniciando sesión...", "Connexion en cours...", "Login läuft...", "Kirjaudutaan...", "Entrando..."]
        
        texts["loginFailed"] = ["Login failed", "Innlogging feilet", "Aanmelden mislukt", "Login mislykkedes", "Inloggningen misslyckades", "Error de inicio de sesion", "Échec de la connexion", "Anmeldung fehlgeschlagen", "Kirjautuminen epäonnistui", "Falha na autenticação"]
        
        texts["pleaseWait"] = ["Please wait...", "Vennligst vent...", "Even wachten...", "Vent et øjeblik...", "Vänligen vänta...", "Un momento, por favor...", "Un instant...", "Bitte warte...", "Odota...", "Por favor, aguarde..."]
        
        texts["loadingFailed"] = ["Loading failed", "Lasting feilet", "Laden mislukt", "Loading mislykkedes", "Hämtningen misslyckades", "La descarga falló", "Chargement échoué", "Laden fehlgeschlagen", "Lataus epäonnistui", "O carregamento falhou"]
        
        texts["connectionError"] = ["Connection error", "Feil ved oppkobling", "Verbindingsfout", "Forbindelsesfejl", "Anslutningsfel", "Error de conexión", "Erreur de connexion", "Verbindungsfehler", "Yhteysvirhe", "Erro de Conexão"]
        
        texts["unknownEmail"] = ["Unknown email", "Ukjent e-post", "Onbekende gebruiker", "Ukendt bruger", "Okänd användare", "Dirección de correo electrónico incorrecta", "Utilisateur inconnu", "Unbekannter Benutzer", "Tuntematon käyttäjä", "Usuário Desconhecido"]
        
        texts["unknownUsername"] = ["Unknown username", "Ukjent brukernavn", "Onbekende gebruiker", "Ukendt bruger", "Okänd användare", "Usuario desconocido", "Utilisateur inconnu", "Unbekannter Benutzer", "Tuntematon käyttäjä", "Usuário Desconhecido"]
        
        texts["wrongPassword"] = ["Wrong password", "Feil passord", "Wachtwoord onjuist", "Forkert adgangskode", "Ogiltigt lösenord", "Contraseña incorrecta", "Mot de passe erroné", "Falsches Passwort", "Virheellinen salasana", "Senha incorreta"]
        
        texts["ok"] = ["OK", "OK", "Oké", "OK", "OK", "Aceptar", "OK", "OK", "OK", "Ok"]
        
        texts["unsupportedLanguage"] = ["Unsupported language", "Språk som ikke støttes", "Niet-ondersteunde taal", "Ikke understøttet sprog", "Språk som inte stöds", "Lenguaje no compatible", "Langue non supportée", "Nicht unterstützte Sprache", "Ei tuettu kieltä", "Linguagem não suportada"]
    }
}
