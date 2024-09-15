sqlite3 = require "lsqlite3"
return function()
    local self = {
        db = sqlite3.open('database/database.sqlite3'), -- open or create db if doent exist

    }
    local setup = function() -- create table if it does not exist
        self.db:exec 'CREATE TABLE IF NOT EXISTS favourite_cities (id INTEGER PRIMARY KEY AUTOINCREMENT,city VARCHAR(100) UNIQUE)'
    end
    setup()                    -- constructor call setup
    local findAll = function() -- find all cities
        return self.db:urows("SELECT city FROM favourite_cities")
    end
    local store = function(name) -- store city
        local stmt = self.db:prepare("INSERT INTO favourite_cities (city) VALUES (?)")
        stmt:bind_values(name)
        stmt:step()
    end
    local destroy = function(name) -- destroy city
        local stmt = self.db:prepare("DELETE FROM favourite_cities WHERE city=?")
        stmt:bind_values(name)
        stmt:step()
    end
    local find = function(name) -- find city
        local stmt = self.db:prepare("SELECT city FROM favourite_cities WHERE city = ?")
        stmt:bind_values(name)
        for city in stmt:urows() do -- check if database found something
            return true
        end
        return false
    end
    return {
        findAll = findAll,
        store = store,
        destroy = destroy,
        find = find,
    }
end
