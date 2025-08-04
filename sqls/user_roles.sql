CREATE TABLE IF NOT EXISTS user_roles (
    "usersId" INTEGER NOT NULL,
    "rolesId" INTEGER NOT NULL,
    PRIMARY KEY ("usersId", "rolesId")
);

SET session_replication_role = replica;