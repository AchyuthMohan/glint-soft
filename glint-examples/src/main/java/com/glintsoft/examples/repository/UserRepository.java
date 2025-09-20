package com.glintsoft.examples.repository;

import com.glintsoft.examples.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

/**
 * Repository interface for User entity.
 */
@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    
    /**
     * Find user by email address.
     */
    Optional<User> findByEmail(String email);
    
    /**
     * Check if user exists by email.
     */
    boolean existsByEmail(String email);
}
