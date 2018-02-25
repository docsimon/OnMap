//
//  DataParsing.swift
//  OnTheMap
//
//  Created by doc on 21/01/2018.
//  Copyright © 2018 Simone Barbara. All rights reserved.
//

// Contains different functions to parse different json files

import Foundation

typealias CompletionClosure = ([Codable?]?, Error?) -> Void
typealias JsonHandlerFunction = (Data, CompletionClosure) -> Void

// Function to parse the Json fetched after sending the Username and Password to
// Udacity
func parseAuthJson(data: Data, completion: CompletionClosure){
    
    let jsonDecoder = JSONDecoder()
    let loginResponse: LoginResponse?
    do {
        loginResponse = try jsonDecoder.decode(LoginResponse.self, from: data)
    }catch {
        print(Constants.Errors.parsingLoginJson)
        sendError(Constants.Errors.parsingLoginJson, "parseAuthJson", completion: completion)
        return
    }
    
    guard let registered = loginResponse?.account.registered, registered == true else{
        sendError(Constants.Errors.userStatus, "parseAuthJson", completion: completion)
        return
    }
    
    guard let _ = loginResponse?.account.key else {
        sendError(Constants.Errors.userKey, "parseAuthJson", completion: completion)
        return
    }
   
    guard let _ = loginResponse?.session.id else {
        sendError(Constants.Errors.userSession, "parseAuthJson", completion: completion)
        return
    }
    
    completion([loginResponse], nil)
}

// Function to parse the Json fetched after posting the Student location
func parsePostStudentLocationJson(data: Data, completion: CompletionClosure){
    
    let jsonDecoder = JSONDecoder()
    let postResponse: StudentLocationResponse?
    do {
        postResponse = try jsonDecoder.decode(StudentLocationResponse.self, from: data)
    }catch {
        print(Constants.Errors.parsingLoginJson)
        sendError(Constants.Errors.parsingLoginJson, "parsePostStudentLocationJson", completion: completion)
        return
    }
    
    guard let _ = postResponse?.objectId else{
        sendError(Constants.Errors.userStatus, "parsePostStudentLocationJson", completion: completion)
        return
    }

    completion([postResponse], nil)
}

// Function to parse the Json fetched after posting the Student location
func parseGetStudentLocationJson(data: Data, completion: CompletionClosure){
    
    let jsonDecoder = JSONDecoder()
    let results: Results?
    do {
        results = try jsonDecoder.decode(Results.self, from: data)
    }catch {
        print(Constants.Errors.parsingStudentJson)
        sendError(Constants.Errors.parsingStudentJson, "parseGetStudentLocationJson", completion: completion)
        return
    }
    
    completion(results?.results, nil)
}

// Function to parse the Json fetched after posting the Student location
func parsePutStudentLocationJson(data: Data, completion: CompletionClosure){
    
    let jsonDecoder = JSONDecoder()
    let putResponse: StudentLocationUpdateResponse?
    do {
        putResponse = try jsonDecoder.decode(StudentLocationUpdateResponse.self, from: data)
    }catch {
        print(Constants.Errors.parsingLoginJson)
        sendError(Constants.Errors.parsingLoginJson, "parsePutStudentLocationJson", completion: completion)
        return
    }
    
    guard let _ = putResponse?.updatedAt else{
        sendError(Constants.Errors.userStatus, "parsePutStudentLocationJson", completion: completion)
        return
    }
    
    completion([putResponse], nil)
}

func parseDeleteSession(data: Data, completion: CompletionClosure){
    
    let jsonDecoder = JSONDecoder()
    let deleteResponse: DeleteResponse?
    do {
        deleteResponse = try jsonDecoder.decode(DeleteResponse.self, from: data)
    }catch {
        print(Constants.Errors.parsingSessionDeleteJson)
        sendError(Constants.Errors.parsingSessionDeleteJson, "parseDeleteSession", completion: completion)
        return
    }
    
    //let sessionId = appDelegate.userLoginData?.userSession
    guard let _ = deleteResponse?.session.id else{
        sendError(Constants.Errors.userSessionStatus, "parseDeleteSession", completion: completion)
        return
    }
    
    completion([deleteResponse], nil)
}
