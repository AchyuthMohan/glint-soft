package com.glintsoft.examples.service;

import com.glintsoft.framework.annotation.GlintService;
import com.glintsoft.framework.annotation.ErrorCode;
import com.glintsoft.framework.exception.GlintException;
import com.glintsoft.examples.model.User;
import com.glintsoft.examples.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

/**
 * Example service using Glint Framework annotations.
 */
@GlintService
public class UserService {
    
    @Autowired
    private UserRepository userRepository;
    
    public List<User> findAll() {
        return userRepository.findAll();
    }
    
    public User findById(Long id) {
        return userRepository.findById(id)
            .orElseThrow(() -> new UserNotFoundException(id));
    }
    
    @Transactional
    public User save(User user) {
        return userRepository.save(user);
    }
    
    @Transactional
    public User update(Long id, User user) {
        if (!userRepository.existsById(id)) {
            throw new UserNotFoundException(id);
        }
        user.setId(id);
        return userRepository.save(user);
    }
    
    @Transactional
    public void deleteById(Long id) {
        if (!userRepository.existsById(id)) {
            throw new UserNotFoundException(id);
        }
        userRepository.deleteById(id);
    }
    
    /**
     * Custom exception for user not found scenarios.
     */
    @ErrorCode(code = "USER_NOT_FOUND", message = "User with ID {0} not found", httpStatus = 404)
    public static class UserNotFoundException extends GlintException {
        public UserNotFoundException(Long userId) {
            super("USER_NOT_FOUND", String.format("User with ID %d not found", userId));
        }
    }
}
