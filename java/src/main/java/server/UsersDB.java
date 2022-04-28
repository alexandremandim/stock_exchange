package server;

import java.util.*;

/**
 * Base de dados dos utilizadores.
 * Metodos synchronized para que a classe possa ser usada
 * por varias threads.
 */
public class UsersDB {

    /**
     * Obtem base de dados por defeito.
     */
    public static UsersDB getDefaultDB(){
        UsersDB res = new UsersDB();
        res.addUser("andre","andre");
        res.addUser("renato","renato");
        res.addUser("alex","alex");
        return res;
    }

    // Map de usernames para passwords
    private Map<String, String> users;
    private Set<String> usersLoggedIn;

    public UsersDB(){
        this.users = new HashMap<>();
        this.usersLoggedIn = new HashSet<>();
    }

    public UsersDB(Map<String, String> users){
        this.users = users;
    }

    public synchronized boolean userExists(String username){
        return users.containsKey(username);
    }

    public synchronized boolean verifyPassword(String username, String password){
        return userExists(username) ? password.compareTo(users.get(username)) == 0 : false;
    }

    public synchronized boolean isLoggedIn(String username){
        return usersLoggedIn.contains(username);
    }

    public synchronized boolean login(String username){
        return usersLoggedIn.add(username);
    }

    public synchronized boolean logout(String username){
        return usersLoggedIn.remove(username);
    }

    public synchronized void addUser(String username, String password){
        users.put(username, password);
    }

    public synchronized Set<String> getUsers(){
        return users.keySet();
    }
}
